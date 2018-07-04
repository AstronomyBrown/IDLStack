/**
 * ExecPlan.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class ExecPlan  implements java.io.Serializable {
    private long planId;
    private java.lang.String format;
    private java.lang.String portalURL;
    private java.lang.String uploadTableName;
    private java.lang.String uploadTableAlias;
    private net.ivoa.SkyPortal.ArrayOfPlanElement planElements;

    public ExecPlan() {
    }


    /**
     * Gets the planId value for this ExecPlan.
     * 
     * @return planId
     */
    public long getPlanId() {
        return planId;
    }


    /**
     * Sets the planId value for this ExecPlan.
     * 
     * @param planId
     */
    public void setPlanId(long planId) {
        this.planId = planId;
    }


    /**
     * Gets the format value for this ExecPlan.
     * 
     * @return format
     */
    public java.lang.String getFormat() {
        return format;
    }


    /**
     * Sets the format value for this ExecPlan.
     * 
     * @param format
     */
    public void setFormat(java.lang.String format) {
        this.format = format;
    }


    /**
     * Gets the portalURL value for this ExecPlan.
     * 
     * @return portalURL
     */
    public java.lang.String getPortalURL() {
        return portalURL;
    }


    /**
     * Sets the portalURL value for this ExecPlan.
     * 
     * @param portalURL
     */
    public void setPortalURL(java.lang.String portalURL) {
        this.portalURL = portalURL;
    }


    /**
     * Gets the uploadTableName value for this ExecPlan.
     * 
     * @return uploadTableName
     */
    public java.lang.String getUploadTableName() {
        return uploadTableName;
    }


    /**
     * Sets the uploadTableName value for this ExecPlan.
     * 
     * @param uploadTableName
     */
    public void setUploadTableName(java.lang.String uploadTableName) {
        this.uploadTableName = uploadTableName;
    }


    /**
     * Gets the uploadTableAlias value for this ExecPlan.
     * 
     * @return uploadTableAlias
     */
    public java.lang.String getUploadTableAlias() {
        return uploadTableAlias;
    }


    /**
     * Sets the uploadTableAlias value for this ExecPlan.
     * 
     * @param uploadTableAlias
     */
    public void setUploadTableAlias(java.lang.String uploadTableAlias) {
        this.uploadTableAlias = uploadTableAlias;
    }


    /**
     * Gets the planElements value for this ExecPlan.
     * 
     * @return planElements
     */
    public net.ivoa.SkyPortal.ArrayOfPlanElement getPlanElements() {
        return planElements;
    }


    /**
     * Sets the planElements value for this ExecPlan.
     * 
     * @param planElements
     */
    public void setPlanElements(net.ivoa.SkyPortal.ArrayOfPlanElement planElements) {
        this.planElements = planElements;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ExecPlan)) return false;
        ExecPlan other = (ExecPlan) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            this.planId == other.getPlanId() &&
            ((this.format==null && other.getFormat()==null) || 
             (this.format!=null &&
              this.format.equals(other.getFormat()))) &&
            ((this.portalURL==null && other.getPortalURL()==null) || 
             (this.portalURL!=null &&
              this.portalURL.equals(other.getPortalURL()))) &&
            ((this.uploadTableName==null && other.getUploadTableName()==null) || 
             (this.uploadTableName!=null &&
              this.uploadTableName.equals(other.getUploadTableName()))) &&
            ((this.uploadTableAlias==null && other.getUploadTableAlias()==null) || 
             (this.uploadTableAlias!=null &&
              this.uploadTableAlias.equals(other.getUploadTableAlias()))) &&
            ((this.planElements==null && other.getPlanElements()==null) || 
             (this.planElements!=null &&
              this.planElements.equals(other.getPlanElements())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        _hashCode += new Long(getPlanId()).hashCode();
        if (getFormat() != null) {
            _hashCode += getFormat().hashCode();
        }
        if (getPortalURL() != null) {
            _hashCode += getPortalURL().hashCode();
        }
        if (getUploadTableName() != null) {
            _hashCode += getUploadTableName().hashCode();
        }
        if (getUploadTableAlias() != null) {
            _hashCode += getUploadTableAlias().hashCode();
        }
        if (getPlanElements() != null) {
            _hashCode += getPlanElements().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ExecPlan.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ExecPlan"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("planId");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "PlanId"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "long"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("format");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "Format"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("portalURL");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "PortalURL"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("uploadTableName");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "UploadTableName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("uploadTableAlias");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "UploadTableAlias"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("planElements");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "PlanElements"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfPlanElement"));
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
