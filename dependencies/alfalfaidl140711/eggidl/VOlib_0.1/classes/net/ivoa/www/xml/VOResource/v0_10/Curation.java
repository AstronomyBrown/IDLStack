/**
 * Curation.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VOResource.v0_10;

public class Curation  implements java.io.Serializable {
    private net.ivoa.www.xml.VOResource.v0_10.ResourceName publisher;
    private net.ivoa.www.xml.VOResource.v0_10.Creator creator;
    private net.ivoa.www.xml.VOResource.v0_10.ResourceName[] contributor;
    private net.ivoa.www.xml.VOResource.v0_10.Date[] date;
    private java.lang.String version;
    private net.ivoa.www.xml.VOResource.v0_10.Contact contact;

    public Curation() {
    }


    /**
     * Gets the publisher value for this Curation.
     * 
     * @return publisher
     */
    public net.ivoa.www.xml.VOResource.v0_10.ResourceName getPublisher() {
        return publisher;
    }


    /**
     * Sets the publisher value for this Curation.
     * 
     * @param publisher
     */
    public void setPublisher(net.ivoa.www.xml.VOResource.v0_10.ResourceName publisher) {
        this.publisher = publisher;
    }


    /**
     * Gets the creator value for this Curation.
     * 
     * @return creator
     */
    public net.ivoa.www.xml.VOResource.v0_10.Creator getCreator() {
        return creator;
    }


    /**
     * Sets the creator value for this Curation.
     * 
     * @param creator
     */
    public void setCreator(net.ivoa.www.xml.VOResource.v0_10.Creator creator) {
        this.creator = creator;
    }


    /**
     * Gets the contributor value for this Curation.
     * 
     * @return contributor
     */
    public net.ivoa.www.xml.VOResource.v0_10.ResourceName[] getContributor() {
        return contributor;
    }


    /**
     * Sets the contributor value for this Curation.
     * 
     * @param contributor
     */
    public void setContributor(net.ivoa.www.xml.VOResource.v0_10.ResourceName[] contributor) {
        this.contributor = contributor;
    }

    public net.ivoa.www.xml.VOResource.v0_10.ResourceName getContributor(int i) {
        return this.contributor[i];
    }

    public void setContributor(int i, net.ivoa.www.xml.VOResource.v0_10.ResourceName value) {
        this.contributor[i] = value;
    }


    /**
     * Gets the date value for this Curation.
     * 
     * @return date
     */
    public net.ivoa.www.xml.VOResource.v0_10.Date[] getDate() {
        return date;
    }


    /**
     * Sets the date value for this Curation.
     * 
     * @param date
     */
    public void setDate(net.ivoa.www.xml.VOResource.v0_10.Date[] date) {
        this.date = date;
    }

    public net.ivoa.www.xml.VOResource.v0_10.Date getDate(int i) {
        return this.date[i];
    }

    public void setDate(int i, net.ivoa.www.xml.VOResource.v0_10.Date value) {
        this.date[i] = value;
    }


    /**
     * Gets the version value for this Curation.
     * 
     * @return version
     */
    public java.lang.String getVersion() {
        return version;
    }


    /**
     * Sets the version value for this Curation.
     * 
     * @param version
     */
    public void setVersion(java.lang.String version) {
        this.version = version;
    }


    /**
     * Gets the contact value for this Curation.
     * 
     * @return contact
     */
    public net.ivoa.www.xml.VOResource.v0_10.Contact getContact() {
        return contact;
    }


    /**
     * Sets the contact value for this Curation.
     * 
     * @param contact
     */
    public void setContact(net.ivoa.www.xml.VOResource.v0_10.Contact contact) {
        this.contact = contact;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Curation)) return false;
        Curation other = (Curation) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.publisher==null && other.getPublisher()==null) || 
             (this.publisher!=null &&
              this.publisher.equals(other.getPublisher()))) &&
            ((this.creator==null && other.getCreator()==null) || 
             (this.creator!=null &&
              this.creator.equals(other.getCreator()))) &&
            ((this.contributor==null && other.getContributor()==null) || 
             (this.contributor!=null &&
              java.util.Arrays.equals(this.contributor, other.getContributor()))) &&
            ((this.date==null && other.getDate()==null) || 
             (this.date!=null &&
              java.util.Arrays.equals(this.date, other.getDate()))) &&
            ((this.version==null && other.getVersion()==null) || 
             (this.version!=null &&
              this.version.equals(other.getVersion()))) &&
            ((this.contact==null && other.getContact()==null) || 
             (this.contact!=null &&
              this.contact.equals(other.getContact())));
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
        if (getPublisher() != null) {
            _hashCode += getPublisher().hashCode();
        }
        if (getCreator() != null) {
            _hashCode += getCreator().hashCode();
        }
        if (getContributor() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getContributor());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getContributor(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getDate() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getDate());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getDate(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getVersion() != null) {
            _hashCode += getVersion().hashCode();
        }
        if (getContact() != null) {
            _hashCode += getContact().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Curation.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Curation"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("publisher");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "publisher"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ResourceName"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("creator");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "creator"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Creator"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("contributor");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "contributor"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ResourceName"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("date");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "date"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Date"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("version");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "version"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("contact");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "contact"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Contact"));
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
