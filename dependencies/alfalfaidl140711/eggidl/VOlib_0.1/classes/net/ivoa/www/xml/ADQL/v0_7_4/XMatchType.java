/**
 * XMatchType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.ADQL.v0_7_4;

public class XMatchType  extends net.ivoa.www.xml.ADQL.v0_7_4.SearchType  implements java.io.Serializable {
    private net.ivoa.www.xml.ADQL.v0_7_4.XMatchTableAliasType[] table;
    private net.ivoa.www.xml.ADQL.v0_7_4.ComparisonType nature;
    private net.ivoa.www.xml.ADQL.v0_7_4.NumberType sigma;

    public XMatchType() {
    }


    /**
     * Gets the table value for this XMatchType.
     * 
     * @return table
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.XMatchTableAliasType[] getTable() {
        return table;
    }


    /**
     * Sets the table value for this XMatchType.
     * 
     * @param table
     */
    public void setTable(net.ivoa.www.xml.ADQL.v0_7_4.XMatchTableAliasType[] table) {
        this.table = table;
    }

    public net.ivoa.www.xml.ADQL.v0_7_4.XMatchTableAliasType getTable(int i) {
        return this.table[i];
    }

    public void setTable(int i, net.ivoa.www.xml.ADQL.v0_7_4.XMatchTableAliasType value) {
        this.table[i] = value;
    }


    /**
     * Gets the nature value for this XMatchType.
     * 
     * @return nature
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.ComparisonType getNature() {
        return nature;
    }


    /**
     * Sets the nature value for this XMatchType.
     * 
     * @param nature
     */
    public void setNature(net.ivoa.www.xml.ADQL.v0_7_4.ComparisonType nature) {
        this.nature = nature;
    }


    /**
     * Gets the sigma value for this XMatchType.
     * 
     * @return sigma
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.NumberType getSigma() {
        return sigma;
    }


    /**
     * Sets the sigma value for this XMatchType.
     * 
     * @param sigma
     */
    public void setSigma(net.ivoa.www.xml.ADQL.v0_7_4.NumberType sigma) {
        this.sigma = sigma;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof XMatchType)) return false;
        XMatchType other = (XMatchType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.table==null && other.getTable()==null) || 
             (this.table!=null &&
              java.util.Arrays.equals(this.table, other.getTable()))) &&
            ((this.nature==null && other.getNature()==null) || 
             (this.nature!=null &&
              this.nature.equals(other.getNature()))) &&
            ((this.sigma==null && other.getSigma()==null) || 
             (this.sigma!=null &&
              this.sigma.equals(other.getSigma())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getTable() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getTable());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getTable(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getNature() != null) {
            _hashCode += getNature().hashCode();
        }
        if (getSigma() != null) {
            _hashCode += getSigma().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(XMatchType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "xMatchType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("table");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Table"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "xMatchTableAliasType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("nature");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Nature"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "comparisonType"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("sigma");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Sigma"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "numberType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
